package mtd.manager.service;

import mtd.manager.dto.NodeDTO;
import mtd.manager.entity.Node;
import mtd.manager.repository.NodeRepository;
import mtd.manager.vo.NodeQueryVO;
import mtd.manager.vo.NodeUpdateVO;
import mtd.manager.vo.NodeVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;

@Service
public class NodeService {

    public static final String CLOUD = "cloud";
    public static final String EDGE = "edge";
    @Autowired
    private NodeRepository nodeRepository;

    public Long save(NodeVO vO) {
        Node bean = new Node();
        BeanUtils.copyProperties(vO, bean);
        bean = nodeRepository.save(bean);
        return bean.getId();
    }

    public void delete(Long id) {
        nodeRepository.deleteById(id);
    }

    public void update(NodeUpdateVO vO) {
        Node bean = requireOne(vO.getId());
        BeanUtils.copyProperties(vO, bean);
        nodeRepository.save(bean);
    }

    public NodeDTO getById(Long id) {
        Node original = requireOne(id);
        return toDTO(original);
    }

    public Page<NodeDTO> query(NodeQueryVO vO) {
        throw new UnsupportedOperationException();
    }

    private NodeDTO toDTO(Node original) {
        NodeDTO bean = new NodeDTO();
        BeanUtils.copyProperties(original, bean);
        return bean;
    }

    private Node requireOne(Long id) {
        return nodeRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Resource not found: " + id));
    }

    public List<NodeDTO> findAll() {
        List<NodeDTO> list = new ArrayList<>();
        nodeRepository.findAll().forEach(node -> list.add(toDTO(node)));
        return list;
    }

    public List<NodeDTO> findAllCloudNode() {
        List<NodeDTO> list = new ArrayList<>();
        nodeRepository.findAllByType(CLOUD).forEach(node -> list.add(toDTO(node)));
        return list;
    }

    public List<NodeDTO> findAllEdgeNode() {
        List<NodeDTO> list = new ArrayList<>();
        nodeRepository.findAllByType(EDGE).forEach(node -> list.add(toDTO(node)));
        return list;
    }

    public boolean isIpUnique(String ipAddress) {
        return !nodeRepository.existsByIpAddress(ipAddress);
    }
}
