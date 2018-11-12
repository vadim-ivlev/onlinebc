select array_to_json(array_agg( row_to_json( t, false ) ), true) from (
	select 
		o.id_trans  идент,
		o.title     "имя"
	from 
		online_trans_list  o
	where
		o.id_trans <80
) t


CREATE OR REPLACE FUNCTION js(t anyelement) returns json   AS $$
begin
    return ( array_to_json(array_agg(to_json( t )),true));
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION get_posts(id anyelement) returns json   AS $$
begin   
    return  
    (
        select array_to_json(array_agg(row_to_json( t, true )),true) 
        from ( 
            select * from online_trans_data where id_trans = id 
        ) t 
    );
    
END;
$$ LANGUAGE plpgsql;

-- test
select get_posts(72);


CREATE OR REPLACE FUNCTION get_broadcast(id anyelement) returns json   AS $$
begin   
    return  
    (
        select row_to_json( t, true )
        from 
        ( select *, get_posts(id) as POSTS  from online_trans_list where id_trans = id limit 1) t 
    );
    
END;
$$ LANGUAGE plpgsql;

-- test
select get_broadcast(72);






-- example
CREATE OR REPLACE FUNCTION get_sum( a NUMERIC, b NUMERIC) RETURNS NUMERIC 
LANGUAGE plpgsql 
AS $$
BEGIN
 RETURN a + b;
END; 
$$
 
select get_sum(10,20);

-- ------------------------

select to_json( t ) from (
    select 
        o.id_trans  идент,
        o.title     "имя"
    from 
        online_trans_list  o
    where
        o.id_trans <80
) t







