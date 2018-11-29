package cn.net.nikai.swagger.ui.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import java.util.List;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * swagger-bootstarp-ui cn.net.nikai.swagger.ui.controller
 *
 * @author: nikai
 * @Description:
 * @Date: Create in 0:41 2018/11/30
 * @Modified By:
 */
@RestController
@Api("专用测试接口")
public class UiController {

    @GetMapping("/names/get")
    @ApiOperation(value = "get all names",notes = "获取所有姓名测试")
    public List<String> getAllNames(@ApiParam("用户id") @RequestParam Integer id)
    {
        return null;
    }

}
