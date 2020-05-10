package org.zerock.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyVO;

public interface ReplyMapper {
	
	public int insert(ReplyVO vo);
	
	public ReplyVO read(Long rno);
	
	public int delete(Long rno);
	
	public int update(ReplyVO reply);
	
	//댓글의 목록과 페이징 처리는 기존의 게시물 페이징 처리와 유사하지만 추가적으로 특정한 게시물의 댓글들만을 데상으로 하기 때문에 추가로 게시물의 번호가 필요
	//MyBatis는 두 개 이상이 데이터를 파라미터로 전달하기 위해서는 별도의 객체로 구성하거나, 맵을 이용하는 방식, @param을 이용하는 방식이 있으며
	//@param의 속성값은 MyBatis에서 sql을 이용할 때 #{}의 이름으로 사용이 가능
	
	//xml로 처리할 때는 지정된 cri와 bno를 모두 사용할 수 있다.
	public List<ReplyVO> getListWithPaging(@Param("cri") Criteria cri, @Param("bno") Long bno);
	
	public int getCountByBno(Long bno);

}
