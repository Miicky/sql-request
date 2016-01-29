SELECT 
        D.price as price,
     	  D.color as color,
        COALESCE(A.count_tickets,0) + COALESCE(B.count_tickets,0) as payed_tickets_count,
        COALESCE(C.count_tickets,0) as returned_tickets_count,
        COALESCE(A.count_tickets,0) + COALESCE(B.count_tickets,0) - COALESCE(C.count_tickets, 0) as result_tickets_count,
        COALESCE(A.PRICE_SUM,0) + COALESCE(B.PRICE_SUM,0) -COALESCE(C.PRICE_SUM,0) as total_price,
        D.event_id,
        D.event_name,
        D.event_start

      FROM 
        (SELECT 
          COALESCE(t1.price,t2.price,t3.price) AS price,
          COALESCE(t1.color,t2.color,t3.color) AS color,
          events.id as event_id,
          events.name as event_name,
          events.event_start
            FROM orders t
            INNER JOIN events on events.id = t.event_id
            LEFT Join orders as parents ON t.parent_order_id = parents.id
            LEFT JOIN tickets t1 ON t1.order_id = t.id and t.status = 'payed'
            LEFT JOIN return_tickets t2 ON t2.order_id = t.id and t.status = 'payed'
            LEFT JOIN return_tickets t3 ON t3.return_order_id = t.id  and t.status = 'returned'
            WHERE (t.created_at BETWEEN '2015-12-30 00:00:00' AND '2015-12-31 23:59:59')  and ((t.status = 'payed' ) or( t.status = 'returned' and parents.status = 'payed'))
            GROUP BY COALESCE(t1.price,t2.price, t3.price), COALESCE(t1.color,t2.color, t3.color), t.event_id
         ) D

      LEFT JOIN 
        (SELECT 
           tickets.price,
           tickets.color,
           events.id as event_id,
           events.name as event_name,
           events.event_start, 
           COUNT(tickets.id) as count_tickets,
           (tickets.price * COUNT(tickets.id)) PRICE_SUM
           FROM orders
           INNER JOIN events on events.id = orders.event_id
           LEFT JOIN tickets ON tickets.order_id = orders.id and orders.status = 'payed'
           WHERE (orders.created_at BETWEEN '2015-12-30 00:00:00' AND '2015-12-31 23:59:59') and price is not null
           GROUP BY tickets.price, tickets.color, event_id
         ) A

      ON D.price = A.price AND D.color = A.color AND D.event_id = A.event_id

      LEFT JOIN 
        (SELECT 
          return_tickets.price,
          return_tickets.color,
          events.id as event_id,
          events.name as event_name,
          events.event_start,
          COUNT(return_tickets.id) as count_tickets,
          (return_tickets.price * COUNT(return_tickets.id)) PRICE_SUM
          FROM orders
          INNER JOIN events on events.id = orders.event_id
          LEFT JOIN return_tickets ON return_tickets.order_id = orders.id  and orders.status = 'payed'
          WHERE (orders.created_at BETWEEN '2015-12-30 00:00:00' AND '2015-12-31 23:59:59') and price is not null
          GROUP BY return_tickets.price, return_tickets.color, event_id
        ) B

      ON D.price = B.price AND D.color = B.color AND D.event_id = B.event_id

      LEFT JOIN 
        (SELECT 
          return_tickets.price,
          return_tickets.color,
          events.id as event_id,
          events.name as event_name,
          events.event_start,
          COUNT(return_tickets.id) as count_tickets,
          (return_tickets.price * COUNT(return_tickets.id)) PRICE_SUM
          FROM orders
          INNER JOIN events on events.id = orders.event_id
          LEFT JOIN return_tickets ON return_tickets.return_order_id = orders.id  and orders.status = 'returned'
          WHERE (orders.created_at BETWEEN '2015-12-30 00:00:00' AND '2015-12-31 23:59:59') and price is not null
          GROUP BY return_tickets.price, return_tickets.color, event_id
        ) C

      ON D.price = C.price AND D.color = C.color AND D.event_id = C.event_id