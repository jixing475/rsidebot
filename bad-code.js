function testUser(user) {
    // 这里的 if (false) 是死代码，应该被 AI 发现
    if (false) {
      console.log("This causes error");
    }
    
    // 这里应该用 == 或 ===，而不是赋值符号 =
    if (user.role = "admin") {
      return true;
    }
  }