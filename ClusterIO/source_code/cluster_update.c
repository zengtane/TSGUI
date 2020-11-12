/*
 * Copyright 2017, Crank Software Inc. All Rights Reserved.
 *
 * For more information email info@cranksoftware.com.
 */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <inttypes.h>
#ifdef WIN32
#include <windows.h>
#else
#include <unistd.h> // for usleep
#endif

#include <gre/greio.h>
#include "ClusterIO_events.h"

/**
 * cross-platform sleep
 */ 
void
sleep_ms(int milliseconds) {
#ifdef WIN32
	Sleep(milliseconds);
#else
	usleep(milliseconds * 1000);
#endif
}

int 
main(int argc, char **argv) {
	gre_io_t                    *send_handle;
    gre_io_serialized_data_t    *nbuffer = NULL;
	cluster_update_event_t 		event_data;
	int 						ret;

	 // Connect to a channel to send messages (write)
	send_handle = gre_io_open("cluster", GRE_IO_TYPE_WRONLY);
    if (send_handle == NULL) {
        fprintf(stderr, "Can't open send channel\n");
        return 0;
	}

	memset(&event_data, 0, sizeof(event_data));

	while(1) {
		// Simulate data acquisition ...
		sleep_ms(80);
		event_data.speed = (event_data.speed + 1) % 200;
		event_data.rpm = (event_data.rpm + 50) % 10000;

		// Serialize the data to a buffer
		nbuffer = gre_io_serialize(nbuffer, NULL, CLUSTER_UPDATE_EVENT, CLUSTER_UPDATE_FMT, &event_data, sizeof(event_data));
		if (!nbuffer) {
        	fprintf(stderr, "Can't serialized data to buffer, exiting\n");
			break;
		}

		// Send the serialized event buffer
		ret = gre_io_send(send_handle, nbuffer);
		if (ret < 0) {
			fprintf(stderr, "Send failed, exiting\n");
			break;
		}
	}

	//Release the buffer memory, close the send handle
	gre_io_free_buffer(nbuffer);
	gre_io_close(send_handle);

	return 0;
}
