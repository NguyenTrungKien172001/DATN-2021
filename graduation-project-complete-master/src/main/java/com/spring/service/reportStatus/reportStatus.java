package com.spring.service.reportStatus;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.dto.model.ReportStatus;
import com.spring.repository.CustomerProfileRepository;

@Service
public class reportStatus {
	@Autowired
	CustomerProfileRepository customerProfileRepository;
	
	public List<ReportStatus> list(int status) {
		List<ReportStatus> list = new ArrayList<>();
		
		customerProfileRepository.reportStatus(status).forEach(obj -> {
			list.add(new ReportStatus(obj[0]+"",obj[1]+"", Integer.parseInt(obj[2]+"")));
		});
		return list;
	}
}
