# 미션 링크

https://www.erdcloud.com/d/xMY5uC36dnoAWpezS

user와 선호도 카테고리는 N : M 관계

미션에는 상태가 3개 있음

도전 전, 도전 중, 도전 완료 → status로 관리

미션을 완료하면 리뷰를 남길 수 있음

식당과 mission 관계는 1 : N 관계

mission을 완료하면 리뷰를 남길 수 있으므로 mission ↔ 리뷰도 1 : N 관계

미션 완료 후 point의 입출금을 추적하며 관리하는 것이 필요 -> point_history 테이블

amount는 +500, -20000 등의 정보가 포함