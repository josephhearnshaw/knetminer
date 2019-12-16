package rres.knetminer.datasource.server;

import java.io.File;
import java.nio.file.Paths;
import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

import javax.annotation.PostConstruct;

import org.apache.commons.lang3.reflect.FieldUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import rres.knetminer.datasource.api.KnetminerDataSource;
import rres.knetminer.datasource.ondexlocal.OndexLocalDataSource;
import rres.knetminer.datasource.ondexlocal.OndexServiceProvider;
import uk.ac.ebi.utils.exceptions.TooFewValuesException;
import uk.ac.ebi.utils.exceptions.TooManyValuesException;
import uk.ac.ebi.utils.exceptions.UnexpectedValueException;
import uk.ac.rothamsted.knetminer.backend.cypher.genesearch.CypherGraphTraverser;

/**
 * TODO: comment me!
 *
 * @author brandizi
 * <dl><dt>Date:</dt><dd>10 Dec 2019</dd></dl>
 *
 */
@RequestMapping( "/cydebug" )
@RestController ()
public class CypherDebuggerService
{
	
	@Autowired
	private List<KnetminerDataSource> dataSources;
	private OndexLocalDataSource dataSource;

	private final static ExecutorService TRAVERSER_EXECUTOR = Executors.newSingleThreadExecutor ();
	private Future<String> traverserStatsResult = null;
	
	public CypherDebuggerService ()
	{
	}

	
	@PostConstruct
	private synchronized void init ()
	{
		if ( this.dataSources == null ) throw new NullPointerException (
			"Cypher Debugger didn't get auto-wired with dataSources" 
		);
		if ( this.dataSources.isEmpty () ) throw new TooFewValuesException (
			"Cypher Debugger got an empty dataSources field" 
		);
		if ( this.dataSources.size () > 1 ) throw new TooManyValuesException (
			"Cypher Debugger doesn't support multiple dataSources, which is deprecated anyway"
		);
		
		KnetminerDataSource ds = this.dataSources.get ( 0 );
		
		if ( ! ( ds instanceof OndexLocalDataSource ) ) new UnexpectedValueException (
			"Cypher Debugger can only worl with instances of " + OndexLocalDataSource.class.getSimpleName ()
		);
		
		this.dataSource = (OndexLocalDataSource) ds;
	}

	
	@RequestMapping ( path = "/traverse", method = { RequestMethod.GET, RequestMethod.POST } )
	public synchronized String newTraverser ( @RequestParam( required = true ) String queries )
	{
		if ( this.traverserStatsResult != null 
				 && traverserStatsResult.isDone () && !traverserStatsResult.isCancelled () )
			return "Done. Invoke /traverser-report";
		// else, if it was cancelled, restart
		
		this.traverserStatsResult = TRAVERSER_EXECUTOR.submit ( this::traverseAgain );
		return "Started. Check progress at /traverser-report";
	}
	
		
	@GetMapping ( path = "/traverser-report", produces = "text/plain; charset=utf-8" )
	public synchronized String traverserReport () throws InterruptedException, ExecutionException
	{
		if ( this.traverserStatsResult == null ) throw new IllegalStateException ( 
			"Wasn't invoked, use /traverse"
		);
		if ( traverserStatsResult.isCancelled () ) throw new IllegalAccessError (
			"Was cancelled, invoke /traverse again"
		);
		if ( !traverserStatsResult.isDone () )
			return "Result not ready. Please call me again later";
		
		return traverserStatsResult.get ();
	}
	
	
	private String traverseAgain ()
	{
		String dataPath = this.dataSource.getProperty ( "DataPath" );
		OndexServiceProvider odxService = this.dataSource.getOndexServiceProvider ();
	
		// TODO: we hack things this way to not toch the messy ODX Provider until it's refactored
		CypherGraphTraverser traverser;
		try {
			traverser = (CypherGraphTraverser) FieldUtils.readField ( odxService, "graphTraverser", true );
		}
		catch ( IllegalAccessException ex )
		{
			throw new IllegalStateException (
				"For some reason the graph traverser isn't accessible ", ex 
			); 
		}

		// It's disabled after init, let's re-enable
		traverser.setOption( "performanceReportFrequency", 0);

		File concept2GeneMapFile = Paths.get ( dataPath, "mapConcept2Genes" ).toFile();
    concept2GeneMapFile.delete ();
    
		odxService.populateHashMaps ( dataSource.getProperty ( "DataFile" ), dataPath );
		// The previous method disabled it again, we need it on in order to make the reporting method
		// behave
		traverser.setOption("performanceReportFrequency", 0);

		try {
			return traverser.getPerformanceStats (); 
		}
		finally {
			// Normally it's disabled.
			traverser.setOption ( "performanceReportFrequency", -1);
		}
	}
}