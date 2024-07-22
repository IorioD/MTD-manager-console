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

    private Integer strategy;
	
	private boolean enabled;
}
