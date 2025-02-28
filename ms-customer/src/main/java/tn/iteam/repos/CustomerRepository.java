package tn.iteam.repos;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import tn.iteam.entities.Customer;
@Repository

public interface CustomerRepository extends JpaRepository<Customer, Long> {

}
