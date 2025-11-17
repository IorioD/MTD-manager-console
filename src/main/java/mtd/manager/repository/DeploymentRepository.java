package mtd.manager.repository;


import mtd.manager.entity.Deployment;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface DeploymentRepository extends JpaRepository<Deployment, Long>, JpaSpecificationExecutor<Deployment> {

    Optional<Deployment> findByNameAndNamespace(String name, String namespace);
}
