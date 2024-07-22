package mtd.manager.controller;

import mtd.manager.dto.ClusterDTO;
import mtd.manager.service.ClusterService;

import java.io.IOException;

import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import io.kubernetes.client.openapi.ApiException;

import org.springframework.web.bind.annotation.CrossOrigin;

import org.slf4j.Logger;

@RestController
@RequestMapping("/cluster")
@CrossOrigin(origins = "http://localhost:8080") // Specifica qui l'origine del frontend
public class ClusterController {

    private static final Logger logger = LoggerFactory.getLogger(ClusterController.class);


    @Autowired
    private ClusterService clusterService;

    @GetMapping("/info")
    public ResponseEntity<ClusterDTO> getClusterInfo() throws IOException, ApiException {
        try {
            ClusterDTO clusterDTO = clusterService.retrieveClusterInfo();
            return ResponseEntity.ok(clusterDTO);
        } catch (IOException e) {
            logger.error("IOException occurred while retrieving cluster info", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(createErrorResponse("IOException occurred while retrieving cluster info"));
        } catch (ApiException e) {
            logger.error("ApiException occurred while retrieving cluster info", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(createErrorResponse("ApiException occurred while retrieving cluster info"));
        } catch (Exception e) {
            logger.error("An unexpected error occurred while retrieving cluster info", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(createErrorResponse("An unexpected error occurred while retrieving cluster info"));
        }
    }

    private ClusterDTO createErrorResponse(String message) {
        ClusterDTO errorResponse = new ClusterDTO();
        errorResponse.setName("Error");
        errorResponse.setApiVersion("N/A");
        errorResponse.setNodeCount(0);
        errorResponse.setArchitecture("N/A");
        errorResponse.setOperatingSystem("N/A");
        errorResponse.setNodeInfoMap(null);
        errorResponse.setNodeMetricsMap(null);
        // Optionally, set other fields to indicate an error
        return errorResponse;
    }
}
