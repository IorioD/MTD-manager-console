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
    private Integer strategy;
    private Boolean enabled;

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

    public String getType() {
        return type;
    }

    public void setType (String type) {
        this.type = type;
    }

    public Integer getStrategy() {
        return strategy;
    }

    public void setStrategy (Integer strategy) {
        this.strategy = strategy;
    }

    public Boolean getEnabled() {
        return enabled;
    }

    public void setEnabled (Boolean enabled) {
        this.enabled = enabled;
    }
}
