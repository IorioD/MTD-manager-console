package mtd.manager.vo;


import lombok.Data;

import java.io.Serializable;

@Data
public class NodeQueryVO implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long id;
    private String hostname;
    private String ipAddress;
    private String role;
    private Boolean available;

}
