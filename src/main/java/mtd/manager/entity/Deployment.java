package mtd.manager.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.io.Serializable;

/*=============================================================================================================
    A Deployment manages a set of Pods to run an application workload, usually one that doesn't maintain state.
    A Deployment provides declarative updates for Pods and ReplicaSets.
    You describe a desired state in a Deployment, and the Deployment Controller changes the actual 
    state to the desired state at a controlled rate. You can define Deployments to create new ReplicaSets, 
    or to remove existing Deployments and adopt all their resources with new Deployments.

    https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
=============================================================================================================*/

@Data
@Entity
@Table(name = "deployment", schema = "mtdmanager")
public class Deployment implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "name", nullable = false)
    private String name;
    @Column(name = "namespace")
    private String namespace;
    @Column(name = "status")
    private String status;
    @Column(name = "type")
    private String type;
    @Column(name = "strategy")
    private Integer strategy;  
	@Column(name = "enabled")
    private Boolean enabled;

    public Boolean isEnabled() {
        return this.enabled;
    }

    public void setEnabled(Boolean enabled) {
        this.enabled = enabled;
    }
}