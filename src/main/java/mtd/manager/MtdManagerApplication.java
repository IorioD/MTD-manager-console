package mtd.manager;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class MtdManagerApplication {

    public static void main(String[] args) {
        SpringApplication.run(MtdManagerApplication.class, args);
    }

}
