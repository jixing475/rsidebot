# Tasks: Refactor to R Package

## 1. Package Skeleton
- [x] 1.1 创建 DESCRIPTION 文件 (包名、版本、依赖)
- [x] 1.2 创建 NAMESPACE 文件 (初始为空，由 roxygen2 生成)
- [x] 1.3 创建 .Rbuildignore 文件
- [x] 1.4 更新 .gitignore 添加 R 包相关忽略项

## 2. Directory Restructure
- [x] 2.1 创建 inst/app/ 目录
- [x] 2.2 移动 app.R 到 inst/app/
- [x] 2.3 创建 inst/app/www/ 并移动静态资源
- [x] 2.4 创建 inst/prompts/ 并移动 prompt.md, greeting.md
- [x] 2.5 创建 inst/extdata/ 并移动 tips.csv
- [x] 2.6 移动 styles.css 到 inst/styles/

## 3. Code Updates
- [x] 3.1 更新 app.R 中的路径引用 (here() → system.file())
- [x] 3.2 为 R/explain-plot.R 添加 roxygen2 文档
- [x] 3.3 创建 R/run_app.R 入口函数
- [x] 3.4 运行 devtools::document() 生成 NAMESPACE 和 man/

## 4. Testing Setup
- [x] 4.1 创建 tests/testthat.R
- [x] 4.2 创建 tests/testthat/test-explain-plot.R 基础测试
- [x] 4.3 运行 devtools::test() 验证测试通过

## 5. Validation
- [x] 5.1 运行 devtools::check() 检查包问题 (0 errors, 0 warnings, 2 notes)
- [x] 5.2 运行 devtools::load_all() 测试加载
- [x] 5.3 调用 run_app() 验证应用正常启动
- [x] 5.4 测试所有现有功能 (聊天、图表、过滤)

## 6. Documentation
- [x] 6.1 更新 README.md 添加安装和使用说明
- [ ] 6.2 清理不再需要的文件 (manifest.json, scripts/) - 保留供参考

## Dependencies
- Task 2 depends on Task 1 (need DESCRIPTION first)
- Task 3 depends on Task 2 (need new paths)
- Task 4 depends on Task 3 (need documented functions)
- Task 5 depends on Task 4 (need complete package)
