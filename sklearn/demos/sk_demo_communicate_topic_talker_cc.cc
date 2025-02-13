#include <memory>

#include <skutils/macro.h>
#include <skutils/printer.h>
#include <skutils/random.h>

#include "sklearn/proto/person.pb.h"

#include "cyber/cyber.h"
#include "cyber/init.h"
#include "cyber/state.h"

using sklearn::proto::Person;

auto GenPerson() -> std::shared_ptr<Person> {
  auto person = std::make_shared<Person>();
  person->set_name(RANDTOOL.getRandomName());
  person->set_age(RANDTOOL.getRandomInt(18, 65));
  person->set_sex((RANDTOOL.coinOnce() ? "male" : "female"));
  auto phome_num = RANDTOOL.getRandomInt(3, 7);
  while (phome_num--) {
    person->add_phone(RANDTOOL.getRandomPhoneNumber());
  }
  return person;
}

auto Person2String(const std::shared_ptr<Person> person) -> std::string {
  auto basic_msg = sk::utils::format(
      "Name: {}, Sex: {}, Age: {}, PhoneNums: {}", person->name(),
      person->sex(), person->age(), person->phone_size());
  return basic_msg;
}

/**
  1. 初始化
  2. 创建节点
  3. 创建发布者
  4. 发布话题数据
  5. 等待节点关闭，释放资源
*/
int main(int /* argc */, char* argv[]) {
  apollo::cyber::Init(argv[0]);
  auto talker_node = apollo::cyber::CreateNode("FirstTalkerAboutPersonGen");
  auto talker = talker_node->CreateWriter<Person>("PersonGen");

  uint32_t sep = 0;
  apollo::cyber::Rate rate(0.5);  // 0.5 msg per second
  while (apollo::cyber::OK()) {
    ++sep;
    auto person = GenPerson();
    SK_LOG("[sk-talker][{}]: {}", sep, Person2String(person));
    talker->Write(person);
    rate.Sleep();
  }

  apollo::cyber::WaitForShutdown();
}