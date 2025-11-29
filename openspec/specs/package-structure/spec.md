# package-structure Specification

## Purpose
TBD - created by archiving change refactor-to-r-package. Update Purpose after archive.
## Requirements
### Requirement: R Package Compliance
包结构 SHALL 符合 R 包标准规范，支持 `devtools::install()` 和 `R CMD check`。

#### Scenario: Package installation
- **WHEN** 用户运行 `devtools::install()`
- **THEN** 包成功安装无错误

#### Scenario: Package check passes
- **WHEN** 运行 `devtools::check()`
- **THEN** 无 ERROR，WARNING 可接受 (如未声明的全局变量)

### Requirement: Application Entry Point
包 SHALL 提供 `run_app()` 函数作为 Shiny 应用的主入口。

#### Scenario: Launch application
- **WHEN** 用户调用 `rsidebot::run_app()`
- **THEN** Shiny 应用在默认浏览器中启动

#### Scenario: Custom port
- **WHEN** 用户调用 `rsidebot::run_app(port = 8080)`
- **THEN** 应用在指定端口 8080 启动

### Requirement: Dependency Declaration
所有运行时依赖 SHALL 在 DESCRIPTION 文件的 `Imports` 字段中声明。

#### Scenario: Fresh installation
- **WHEN** 在新环境中安装包
- **THEN** 所有依赖自动安装

#### Scenario: Namespace isolation
- **WHEN** 包加载后
- **THEN** 依赖包不会附加到用户搜索路径 (不使用 Depends)

### Requirement: Resource File Access
包内资源文件 SHALL 通过 `system.file()` 访问，而非硬编码路径。

#### Scenario: Access prompt files
- **WHEN** 应用需要读取 prompt.md
- **THEN** 使用 `system.file("prompts/prompt.md", package = "rsidebot")`

#### Scenario: Access static assets
- **WHEN** Shiny 应用需要 CSS/JS 文件
- **THEN** 从 `inst/` 对应子目录加载

### Requirement: Function Documentation
导出函数 SHALL 使用 roxygen2 格式文档，包含参数说明和示例。

#### Scenario: Help documentation
- **WHEN** 用户运行 `?run_app`
- **THEN** 显示函数文档，包含 Description、Arguments、Examples

### Requirement: Test Infrastructure
包 SHALL 包含 testthat 测试框架配置，至少有一个通过的测试用例。

#### Scenario: Run tests
- **WHEN** 运行 `devtools::test()`
- **THEN** 测试套件执行，至少一个测试通过

