package com.github.zuihoou.generator.config;

import java.io.File;

import com.baomidou.mybatisplus.extension.toolkit.PackageHelper;
import com.baomidou.mybatisplus.generator.config.IFileCreate;
import com.baomidou.mybatisplus.generator.config.builder.ConfigBuilder;
import com.baomidou.mybatisplus.generator.config.rules.FileType;
import com.github.zuihoou.generator.type.GenerateType;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.Accessors;

/**
 * 文件创建配置类
 *
 * @author zuihou
 * @date 2019-05-25
 */
@Data
@Accessors(chain = true)
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FileCreateConfig implements IFileCreate {

    private GenerateType generate;
    private GenerateType generateEnum = GenerateType.OVERRIDE;
    private GenerateType generateEntity = GenerateType.OVERRIDE;
    private GenerateType generateConstant = GenerateType.IGNORE;
    private GenerateType generateDto = GenerateType.IGNORE;
    private GenerateType generateDao = GenerateType.IGNORE;
    private GenerateType generateXml = GenerateType.IGNORE;
    private GenerateType generateService = GenerateType.IGNORE;
    private GenerateType generateServiceImpl = GenerateType.IGNORE;
    private GenerateType generateController = GenerateType.IGNORE;

    private GenerateType generateQuery = GenerateType.IGNORE;
    private GenerateType generateApi = GenerateType.IGNORE;

    /**
     * 指定了generate后， 会覆盖 controller、service、dao等生成策略
     *
     * @param generate
     */
    public FileCreateConfig(GenerateType generate) {
        this.generate = generate;
        if (generate != null) {
            this.generateEntity = generate;
            this.generateDao = generate;
            this.generateXml = generate;
            this.generateService = generate;
            this.generateServiceImpl = generate;
            this.generateController = generate;
            this.generateEnum = generate;
            this.generateDto = generate;
        }
        this.generateConstant = GenerateType.IGNORE;
        this.generateQuery = GenerateType.IGNORE;
        this.generateApi = GenerateType.IGNORE;
    }

    /**
     * 判断文件是否存在
     *
     * @param path 路径
     */
    public static boolean isExists(String path) {
        File file = new File(path);
        return file.exists();
    }

    @Override
    public boolean isCreate(ConfigBuilder configBuilder, FileType fileType, String filePath) {
        File file = new File(filePath);
        if (this.generate != null) {
            if (filePath.contains(File.separator + "constant" + File.separator)) {
                return isCreate(generateConstant, file);
            }
            if (filePath.contains(File.separator + "query" + File.separator)) {
                return isCreate(generateQuery, file);
            }
            if (filePath.contains(File.separator + "api" + File.separator)) {
                return isCreate(generateApi, file);
            }
            return isCreate(generate, file);
        }
        //实体
        if (FileType.ENTITY == fileType) {
            return isCreate(generateEntity, file);
            //控制器
        } else if (FileType.CONTROLLER == fileType) {
            return isCreate(generateController, file);
            //dao
        } else if (FileType.XML == fileType) {
            return isCreate(generateXml, file);
        } else if (FileType.MAPPER == fileType) {
            return isCreate(generateDao, file);
            //service
        } else if (FileType.SERVICE == fileType) {
            return isCreate(generateService, file);
        } else if (FileType.SERVICE_IMPL == fileType) {
            return isCreate(generateServiceImpl, file);
        } else if (FileType.OTHER == fileType) {
            if (filePath.contains(File.separator + "enumeration" + File.separator)) {
                return isCreate(generateEnum, file);
            }
            if (filePath.contains(File.separator + "constant" + File.separator)) {
                return isCreate(generateConstant, file);
            }
            if (filePath.contains(File.separator + "query" + File.separator)) {
                return isCreate(generateQuery, file);
            }
            if (filePath.contains(File.separator + "api" + File.separator)) {
                return isCreate(generateApi, file);
            }
            if (filePath.contains(File.separator + "entity" + File.separator)) {
                return isCreate(generateEntity, file);
            }
            if (filePath.contains(File.separator + "dto" + File.separator)) {
                return isCreate(generateDto, file);
            }
            //控制器
            if (filePath.contains(File.separator + "controller" + File.separator)) {
                return isCreate(generateController, file);
            }
            //dao
            if (filePath.contains(File.separator + "mapper_")) {
                return isCreate(generateXml, file);
            }
            if (filePath.contains(File.separator + "dao" + File.separator)) {
                return isCreate(generateDao, file);
            }
            if (filePath.contains(File.separator + "service" + File.separator)) {
                return isCreate(generateService, file);
            }
            if (filePath.contains(File.separator + "impl" + File.separator)) {
                return isCreate(generateServiceImpl, file);
            }

        }
        return true;
    }

    private boolean isCreate(GenerateType gen, File file) {
        if (GenerateType.IGNORE.eq(gen)) {
            return false;
        }
        if (!file.exists()) {
            PackageHelper.mkDir(file.getParentFile());
        }
        return true;
    }

}
