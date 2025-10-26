package mtd.manager.dto;


import lombok.Data;

import java.io.Serializable;

@Data
public class NodeDTO implements Serializable {
    private static final long serialVersionUID = 1L;
    private String hostname;
    private String ipAddress;
    private Long id;
    private String role;
    private String type;
    private String available;


    public String gethostname() {
        return hostname;
    }

    public void sethostname (String hostname) {
        this.hostname = hostname;
    }

    public String getipAddress() {
        return ipAddress;
    }
    
    public void setipAddress (String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public String getRole() {
        return role;
    }

    public void setRole (String role) {
        this.role = role;
    }

    public String getType() {  
        return type;
    }
    
    public void setType (String type) {
        this.type = type;
    }
    
    public String getAvailable() {
        return available;
    }                  

    public void setAvailable (String available) {
        this.available = available;
    }
}