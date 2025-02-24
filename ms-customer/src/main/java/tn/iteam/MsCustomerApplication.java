package tn.iteam;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import tn.iteam.entities.Customer;
import tn.iteam.repos.CustomerRepository;

@SpringBootApplication
public class MsCustomerApplication {
    @Autowired //injection de dependance
    private CustomerRepository customerRepository;
    public static void main(String[] args) {

        SpringApplication.run(MsCustomerApplication.class, args);
        System.out.println("customer service started successfully!!");
    }
    @Bean //une instance pres à s'exucuter
    public CommandLineRunner init() {
        return args -> {
           
        };
    }

}
