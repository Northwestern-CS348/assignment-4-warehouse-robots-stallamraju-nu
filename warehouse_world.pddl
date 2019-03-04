(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action robotMove
      :parameters (?a - location ?b - location ?r - robot)
      :precondition (and (free ?r) (connected ?a ?b) (at ?r ?a) (not (at ?r ?b)) (no-robot ?b) (not (no-robot ?a)))
      :effect (and (at ?r ?b) (not (at ?r ?a)) (no-robot ?a) (not (no-robot ?b)))
   )
   
   (:action robotMoveWithPallette
      :parameters (?a - location ?b - location ?r - robot ?p - pallette)
      :precondition (and (connected ?a ?b) (at ?r ?a) (at ?p ?a) (not (at ?r ?b)) (not (at ?p ?b)) (no-robot ?b) (not (no-robot ?a)) (no-pallette ?b) (not (no-pallette ?a)))
      :effect (and (at ?r ?b) (at ?p ?b) (not (at ?r ?a)) (not (at ?p ?a)) (no-robot ?a) (not (no-robot ?b)) (no-pallette ?a) (not (no-pallette ?b)))
   )
   
   (:action moveItemFromPalletteToShipment
      :parameters (?l - location ?s - shipment ?i - saleitem ?p - pallette ?o - order)
      :precondition (and (ships ?s ?o) (orders ?o ?i) (not (unstarted ?s)) (started ?s) (not (complete ?s)) (not (includes ?s ?i)) (packing-location ?l) (packing-at ?s ?l) (not (available ?l)) (at ?p ?l) (not (no-pallette ?l)) (contains ?p ?i))
      :effect (and (includes ?s ?i) (not (contains ?p ?i)))
   )
   
   (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (ships ?s ?o) (not (unstarted ?s)) (started ?s) (not (complete ?s)) (packing-location ?l) (packing-at ?s ?l) (not (available ?l)))
      :effect (and (complete ?s) (not (packing-at ?s ?l)) (available ?l))
   )
)