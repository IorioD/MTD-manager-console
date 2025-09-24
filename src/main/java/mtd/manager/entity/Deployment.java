package mtd.manager.entity;

import jakarta.persistence.*;
import lombok.Data;

import java.io.Serializable;

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

    @Column(name = "type")
    private String type;

    @Column(name = "node_name")
    private String nodeName;

    @Column(name = "status")
    private String status;

    @Column(name = "podip")
    private String podIp;

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

    public String getNodeName() {
        return nodeName;
    }

    public void setNodeName(String nodeName) {
        this.nodeName = nodeName;
    }
}
