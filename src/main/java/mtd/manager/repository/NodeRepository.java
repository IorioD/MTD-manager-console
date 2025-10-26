package mtd.manager.repository;

import mtd.manager.entity.Node;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface NodeRepository extends JpaRepository<Node, Long>, JpaSpecificationExecutor<Node> {

    @Query(nativeQuery = true, value = "SELECT * FROM mtdmanager.node WHERE available=true ORDER BY random() LIMIT 1")
    Node findRandomNode();

    @Query(nativeQuery = true, value = "SELECT * FROM mtdmanager.node WHERE available=true AND role='worker' ORDER BY random() LIMIT 1")
    Node findRandomWorkerNode();

    @Query(nativeQuery = true, value = "SELECT * FROM mtdmanager.node WHERE available=true AND role='edge' ORDER BY random() LIMIT 1")
    Node findRandomEdgeNode();

    @Query(nativeQuery = true, value = "SELECT * FROM mtdmanager.node WHERE available=true AND type = ?1 ORDER BY random() LIMIT 1")
    Node findRandomNodeByType(String type);

    List<Node> findAllByType(String type);

    boolean existsByIpAddress(String ipAddress);

    Optional<Node> findByIpAddress(String ipAddress);
}