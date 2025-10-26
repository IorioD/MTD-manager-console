package mtd.manager.vo;


import lombok.Data;

import java.io.Serializable;

@Data
public class PodQueryVO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private String name;
    private String namespace;
    private String type;
    private String nodeName;
    private String status;
    private String podIp;
    private Integer strategy;	
    private Boolean enabled;
    private Integer idDeplo;
}
