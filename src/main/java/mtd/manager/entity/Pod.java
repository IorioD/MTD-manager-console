package mtd.manager.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.io.Serializable;

/*=============================================================================================================
    Pods are the smallest deployable units of computing that you can create and manage in Kubernetes.
    A Pod (as in a pod of whales or pea pod) is a group of one or more containers, with shared storage 
    and network resources, and a specification for how to run the containers. A Pod's contents are always 
    co-located and co-scheduled, and run in a shared context. A Pod models an application-specific "logical host": 
    it contains one or more application containers which are relatively tightly coupled. In non-cloud contexts, 
    applications executed on the same physical or virtual machine are analogous to cloud applications executed on 
    the same logical host.
    As well as application containers, a Pod can contain init containers that run during Pod startup. 
    You can also inject ephemeral containers for debugging a running Pod

    https://kubernetes.io/docs/concepts/workloads/pods/
=============================================================================================================*/

@Data
@Entity
@Table(name = "pod", schema = "mtdmanager")
public class Pod implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "name", nullable = false)
    private String name;
    @Column(name = "namespace")
    private String namespace;
    @Column(name = "type")
    private String type;
    @Column(name = "node_name")
    private String nodeName;
    @Column(name = "status")
    private String status;
    @Column(name = "pod_ip")
    private String podIp; 
	@Column(name = "enabled")
    private Boolean enabled;
    @Column(name = "id_deplo")
    private Long id_deplo;
	
	public Boolean isEnabled() {
        return this.enabled;
    }

    public void setEnabled(Boolean enabled) {
        this.enabled = enabled;
    }

    public String getNodeName() {
        return nodeName;
    }

    public void setNodeName(String nodeName) {
        this.nodeName = nodeName;
    }
}
