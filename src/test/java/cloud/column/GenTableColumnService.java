package cloud.column;

import com.tangyh.lamp.generator.model.GenTableColumn;

import java.util.Map;

/**
 * @author zuihou
 * @version v1.0
 * @date 2021/5/13 12:30 下午
 * @create [2021/5/13 12:30 下午 ] [zuihou] [初始创建]
 */
public interface GenTableColumnService {
    Map<String, Map<String, GenTableColumn>> map();
}
