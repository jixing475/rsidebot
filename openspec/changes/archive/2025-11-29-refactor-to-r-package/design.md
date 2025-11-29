# Design: R Package Structure

## Context
r-sidebot 是一个使用 querychat 的 Shiny 数据仪表板应用。当前为单文件应用结构，需要重构为标准 R 包以提升可维护性和可分发性。

## Goals / Non-Goals

**Goals:**
- 符合 CRAN 标准的 R 包结构
- 保持现有功能完全兼容
- 支持 `devtools::install()` 安装
- 支持 `roxygen2` 文档生成
- 支持 `testthat` 单元测试

**Non-Goals:**
- 不发布到 CRAN (保留本地/GitHub 安装)
- 不改变现有 UI/UX
- 不添加新功能

## Decisions

### 1. 包名称
- **Decision**: 保持 `rsidebot` 作为包名 (去掉连字符)
- **Rationale**: R 包名不允许连字符

### 2. 应用入口
- **Decision**: 创建 `run_app()` 函数作为主入口
- **Rationale**: 标准 Shiny 包模式，便于用户启动应用
- **Alternatives**: 
  - 直接 `shiny::runApp(system.file("app", package = "rsidebot"))` - 不够友好

### 3. 资源文件位置
- **Decision**: 
  - `inst/app/` - Shiny 应用文件 (app.R, ui.R, server.R)
  - `inst/app/www/` - 静态资源 (CSS, JS, 图片)
  - `inst/extdata/` - 示例数据 (tips.csv)
  - `inst/prompts/` - AI 提示词文件 (prompt.md, greeting.md)
- **Rationale**: 遵循 R 包惯例，`inst/` 内容安装后可通过 `system.file()` 访问

### 4. 配置管理
- **Decision**: 环境变量保持不变，可选添加 `config.yml` 支持
- **Rationale**: 不破坏现有部署配置

### 5. 依赖声明
- **Decision**: 在 DESCRIPTION 中使用 `Imports` 而非 `Depends`
- **Rationale**: 避免污染用户命名空间

## Target Directory Structure

```
rsidebot/
├── DESCRIPTION
├── NAMESPACE
├── LICENSE
├── README.md
├── R/
│   ├── run_app.R          # run_app() 入口函数
│   ├── explain-plot.R     # 现有函数 (添加文档)
│   └── utils.R            # 辅助函数
├── inst/
│   ├── app/
│   │   ├── app.R          # Shiny 应用主文件
│   │   └── www/
│   │       └── stars.svg
│   ├── prompts/
│   │   ├── prompt.md
│   │   └── greeting.md
│   ├── extdata/
│   │   └── tips.csv
│   └── styles/
│       └── styles.css
├── man/                    # roxygen2 生成
│   └── run_app.Rd
├── tests/
│   ├── testthat.R
│   └── testthat/
│       └── test-explain-plot.R
└── .Rbuildignore
```

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| 路径引用失效 | 使用 `system.file()` 替换 `here()` |
| 开发流程改变 | 提供 `devtools::load_all()` 工作流文档 |
| CI/CD 需要更新 | 更新部署脚本使用包安装方式 |

## Migration Plan

1. 创建包骨架 (DESCRIPTION, NAMESPACE)
2. 移动文件到 `inst/` 目录
3. 更新路径引用 (`here()` → `system.file()`)
4. 添加 roxygen2 文档
5. 创建 `run_app()` 入口
6. 添加基础测试
7. 验证功能完整性

## Open Questions

- [ ] 是否需要支持 `config.yml` 配置文件？
- [ ] 是否需要添加 pkgdown 文档网站？
- [ ] tips.duckdb 文件是否需要包含在包中？
