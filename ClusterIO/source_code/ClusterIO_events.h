#define CLUSTER_UPDATE_EVENT "cluster_update"
#define CLUSTER_UPDATE_FMT "2u1 speed 2u1 rpm 2u1 fuel 2u1 battery 2u1 oil 2u1 odometer 2u1 trip"
typedef struct {
	uint16_t 		speed;
	uint16_t 		rpm;
	uint16_t 		fuel;
	uint16_t 		battery;
	uint16_t 		oil;
	uint16_t 		odometer;
	uint16_t 		trip;
} cluster_update_event_t;

