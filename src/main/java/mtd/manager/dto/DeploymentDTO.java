package mtd.manager.dto;


import lombok.Data;

import java.io.Serializable;

@Data
public class DeploymentDTO implements Serializable {
    private static final long serialVersionUID = 1L;
    private String name;
    private String namespace;
    private Long id;
    private String type;
    private String nodeName;
    private String status;
    private String podIp;
    private Integer strategy;
	private boolean enabled;


    public String getName() {
        return name;
    }  

    public void setName (String name) {
        this.name = name;
    }  

    public String getNamespace() {
        return namespace;
    }  

    public void setNamespace (String namespace) {
        this.namespace = namespace;
    }


    public String getType() {
        return type;
    }

    public void setType (String type) {
        this.type = type;
    }

    public String getNodeName() {
        return nodeName;
    }

    public void setNodeName (String nodeName) {
        this.nodeName = nodeName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus (String status) {
        this.status = status;
    }

    public String getPodIp() {
        return podIp;
    }

    public void setPodIp(String podIp) {
        this.podIp = podIp;
    }

}
