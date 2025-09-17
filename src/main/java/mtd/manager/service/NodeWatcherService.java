package mtd.manager.service;

import io.kubernetes.client.openapi.ApiClient;
import io.kubernetes.client.openapi.apis.CoreV1Api;
import io.kubernetes.client.util.Watch;
import io.kubernetes.client.openapi.models.*;

import com.google.gson.reflect.TypeToken;
import okhttp3.Call;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import java.util.concurrent.Executors;

@Service
public class NodeWatcherService {

    private final NodeService nodeService;

    public NodeWatcherService(NodeService nodeService) {
        this.nodeService = nodeService;
    }

    @PostConstruct
    public void startWatcher() throws Exception {
        ApiClient client = io.kubernetes.client.util.Config.defaultClient();
        CoreV1Api api = new CoreV1Api(client);

        // Avvio watcher in un thread separato
        Executors.newSingleThreadExecutor().submit(() -> {
            try {
                Call call = api.listNodeCall(
                        null, null, null, null,
                        null, null, null,
                        null, null, 
                        true, null);

                Watch<V1Node> watch = Watch.createWatch(
                        client,
                        call,
                        new TypeToken<Watch.Response<V1Node>>(){}.getType()
                );

                for (Watch.Response<V1Node> event : watch) {
                    V1ObjectMeta meta = event.object.getMetadata();
                    String name = (meta != null) ? meta.getName() : "unknown";

                    System.out.printf("Node event: %s %s%n", event.type, name);
                    // synch each ADD / UPDATE / DELETE event
                    nodeService.syncNodesFromKubernetes();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
    }
}