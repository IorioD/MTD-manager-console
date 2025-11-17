package mtd.manager.vo;


import lombok.Data;

import java.io.Serializable;

@Data
public class DeploymentQueryVO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private String name;
    private String namespace;
    private String status;
    private String type;
    private Integer strategy;
    private Boolean enabled;
}
