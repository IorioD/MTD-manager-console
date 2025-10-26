package mtd.manager.vo;

import lombok.Data;

import javax.validation.constraints.NotNull;
import java.io.Serializable;


@Data
public class PodVO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;

    @NotNull(message = "name cannot be null")
    private String name;
    private String namespace;
    private String type;
    private String nodeName;
    private String status;
    private String podIp;
    @NotNull(message = "strategy cannot be null")
    private Integer strategy;  
    private Boolean enabled;
    private Integer idDeplo;
}
