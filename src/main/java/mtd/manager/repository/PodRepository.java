package mtd.manager.repository;


import mtd.manager.entity.Pod;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface PodRepository extends JpaRepository<Pod, Long>, JpaSpecificationExecutor<Pod> {

    Pod findByName(String name);
}