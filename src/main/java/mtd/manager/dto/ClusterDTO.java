package mtd.manager.dto;

import java.util.Map;

public class ClusterDTO {
    private String name;
    private String apiVersion;
    private int nodeCount;
    private String architecture;
    private String operatingSystem;
    private Map<String, NodeInfo> nodeInfoMap;
    private Map<String, NodeMetrics> nodeMetricsMap;

    // Getters and Setters
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getApiVersion() {
        return apiVersion;
    }

    public void setApiVersion(String apiVersion) {
        this.apiVersion = apiVersion;
    }

    public int getNodeCount() {
        return nodeCount;
    }

    public void setNodeCount(int nodeCount) {
        this.nodeCount = nodeCount;
    }

    public String getArchitecture() {
        return architecture;
    }

    public void setArchitecture(String architecture) {
        this.architecture = architecture;
    }

    public String getOperatingSystem() {
        return operatingSystem;
    }

    public void setOperatingSystem(String operatingSystem) {
        this.operatingSystem = operatingSystem;
    }

    public Map<String, NodeInfo> getNodeInfoMap() {
        return nodeInfoMap;
    }

    public void setNodeInfoMap(Map<String, NodeInfo> nodeInfoMap) {
        this.nodeInfoMap = nodeInfoMap;
    }

    public Map<String, NodeMetrics> getNodeMetricsMap() {
        return nodeMetricsMap;
    }

    public void setNodeMetricsMap(Map<String, NodeMetrics> nodeMetricsMap) {
        this.nodeMetricsMap = nodeMetricsMap;
    }

    public static class NodeInfo {
        private String architecture;
        private String operatingSystem;

        public NodeInfo(String architecture, String operatingSystem) {
            this.architecture = architecture;
            this.operatingSystem = operatingSystem;
        }

        public String getArchitecture() {
            return architecture;
        }

        public void setArchitecture(String architecture) {
            this.architecture = architecture;
        }

        public String getOperatingSystem() {
            return operatingSystem;
        }

        public void setOperatingSystem(String operatingSystem) {
            this.operatingSystem = operatingSystem;
        }
    }

    public static class NodeMetrics {
        private String cpuUsage;
        private String memUsage;
        private String diskUsage;

        public NodeMetrics() {
            this.cpuUsage = null;
            this.memUsage = null;
            this.diskUsage = null;
        }

        public NodeMetrics(String cpuUsage, String memUsage, String diskUsage) {
            this.cpuUsage = cpuUsage;
            this.memUsage = memUsage;
            this.diskUsage = diskUsage;
        }

        public String getCpuUsage() {
            return cpuUsage;
        }

        public void setCpuUsage(String cpuUsage) {
            this.cpuUsage = cpuUsage;
        }

        public String getMemUsage() {
            return memUsage;
        }

        public void setMemUsage(String memUsage) {
            this.memUsage = memUsage;
        }

        public String getDiskUsage() {
            return diskUsage;
        }

        public void setDiskUsage(String diskUsage) {
            this.diskUsage = diskUsage;
        }
    }
}
