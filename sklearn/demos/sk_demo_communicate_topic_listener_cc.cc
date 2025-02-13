#include <memory>

#include <skutils/macro.h>

#include "sklearn/proto/person.pb.h"

#include "cyber/cyber.h"
#include "cyber/init.h"
#include "cyber/state.h"

#undef SK_LOG_FOR_DEBUG
#define SK_LOG_FOR_DEBUG 0

using sklearn::proto::Person;

auto FilterPerson_cb(const std::shared_ptr<Person> person) {
  SK_LOG("[sk-listener] PersonNamed {}", person->name());
}

/**
  1. 创建节点
  2. 创建订阅者/读者
  3. 读取消息
  4. 终止回收资源
*/
int main(int /* argc */, char* argv[]) {
  apollo::cyber::Init(argv[0]);
  auto listener_node = apollo::cyber::CreateNode("PersonGenTopicListener001");
  auto listener =
      listener_node->CreateReader<Person>("PersonGen", FilterPerson_cb);
  apollo::cyber::WaitForShutdown();

  listener->HasReceived();
}