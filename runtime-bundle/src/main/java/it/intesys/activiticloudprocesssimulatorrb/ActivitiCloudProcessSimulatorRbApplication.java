package it.intesys.activiticloudprocesssimulatorrb;

import org.activiti.cloud.starter.rb.configuration.ActivitiRuntimeBundle;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@ActivitiRuntimeBundle
public class ActivitiCloudProcessSimulatorRbApplication {

	public static void main(String[] args) {
		SpringApplication.run(ActivitiCloudProcessSimulatorRbApplication.class, args);
	}

}
