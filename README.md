<p>Tables
  <p>Orders
    <p>id, status, created_at, event_id, parent_order_id </p>
  </p>
  <p>Events
    <p>id, name, event_start</p>
  </p>
  <p>Tickets
    <p>id, order_id, price, color</p>
  </p>
  <p>ReturnTickets
    <p>id, order_id, price, color</p>
  </p>
</p>

Need to translate

Приклад
01.01.16 продали три квитки по 50 грн
02.01.16 повернули 1 квиток за 50 грн (з цього ж ордера)


Звіт за 01.01.16
Вертає

price, color, payed_tickets_count, returned_tickets_count, result_tickets_count, total_price, event_name, event_start
50   , red  , 3                  , 0                     , 3                   , 150        , lolo      , 2016-01-03 00:00:00

Звіт за 01-02.01.16
Вертає

price, color, payed_tickets_count, returned_tickets_count, result_tickets_count, total_price, event_name, event_start
50   , red  , 3                  , 1                     , 2                   , 100        , lolo      , 2016-01-03 00:00:00

Звіт за 002.01.16
Вертає

price, color, payed_tickets_count, returned_tickets_count, result_tickets_count, total_price, event_name, event_start
50   , red  , 0                  , 1                     , 0                   , -50        , lolo      , 2016-01-03 00:00:00
