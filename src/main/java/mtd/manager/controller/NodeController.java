package mtd.manager.controller;

import mtd.manager.dto.NodeDTO;
import mtd.manager.service.NodeService;
import mtd.manager.vo.NodeQueryVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import javax.validation.constraints.NotNull;
import java.util.List;

@Validated
@RestController
@RequestMapping("/node")
public class NodeController {

    @Autowired
    private NodeService nodeService;

    @GetMapping("/{id}")
    public NodeDTO getById(@Valid @NotNull @PathVariable("id") Long id) {
        return nodeService.getById(id);
    }

    @GetMapping
    public Page<NodeDTO> query(@Valid NodeQueryVO vO) {
        return nodeService.query(vO);
    }

    @GetMapping("/all")
    public List<NodeDTO> findAll() {
        return nodeService.findAll();
    }

    @GetMapping("/cloud/all")
    public List<NodeDTO> findAllCloudNode() {
        return nodeService.findAllCloudNode();
    }

    @GetMapping("/edge/all")
    public List<NodeDTO> findAllEdgeNode() {
        return nodeService.findAllEdgeNode();
    }
}
