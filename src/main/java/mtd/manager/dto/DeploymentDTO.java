package mtd.manager.dto;


import lombok.Data;

import java.io.Serializable;

@Data
public class DeploymentDTO implements Serializable {
    private static final long serialVersionUID = 1L;
    private Long id;
    private String name;
    private String namespace;
    private String status;
    private String type;

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

    public String getStatus() {
        return status;
    }

    public void setStatus (String status) {
        this.status = status;
    }
}
