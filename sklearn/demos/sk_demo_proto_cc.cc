#include "sklearn/proto/person.pb.h"

#include "cyber/common/log.h"
#include "cyber/cyber.h"
#include "cyber/init.h"

int main(int argc, char* argv[]) {
  sklearn::proto::Person p;

  p.set_name("zhangsan");
  p.set_age(16);
  p.set_sex("male");
  p.add_phone("123456");
  p.add_phone("234567");

  auto cnt = p.phone_size();

  std::cout << "Phone-Size: " << cnt << std::endl;
  for (int i = 0; i < p.phone_size(); i++) {
    std::cout << "\t" << p.phone(i) << "\n";
  }
}