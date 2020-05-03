package org.zerock.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@ToString
@Setter
@Getter
public class Criteria {

	private int pageNum;
	private int amount;

	// 검색을 위해 type과 keyword 추가
	private String type;
	private String keyword;

	public Criteria() {
		this(1, 10);
	}

	public Criteria(int pageNum, int amount) {
		this.pageNum = pageNum;
		this.amount = amount;
	}

	// 검색 조건이 각 글자 (T, W, C)로 구성되어 있으므로 검색 조건을 배열로 만듬
	public String[] getTypeArr() {

		return type == null ? new String[] {} : type.split("");
	}

}