package mtd.manager.vo;

import lombok.Data;

import javax.validation.constraints.NotNull;
import java.io.Serializable;


@Data
public class DeploymentVO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    @NotNull(message = "name cannot be null")
    private String name;
    private String namespace;
    private String status;
    private String type;
    @NotNull(message = "strategy cannot be null")
    private Integer strategy;
    private Boolean enabled;
}
