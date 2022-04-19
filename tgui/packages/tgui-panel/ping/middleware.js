/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { pingSuccess } from './actions';
import { PING_INTERVAL } from './constants';

export const pingMiddleware = store => {
  let initialized = false;
  let index = 0;
  let interval;
  const pings = [];
  const sendPing = () => { /* SKYRAT EDIT START - Trying to fix the chat
    for (let i = 0; i < PING_QUEUE_SIZE; i++) {
      const ping = pings[i];
      if (ping && Date.now() - ping.sentAt > PING_TIMEOUT) {
        pings[i] = null;
        store.dispatch(pingFail());
      }
    }
    const ping = { index, sentAt: Date.now() };
    pings[index] = ping;
    sendMessage({
      type: 'ping',
      payload: { index },
    });
    Byond.sendMessage('ping', { index });
    index = (index + 1) % PING_QUEUE_SIZE;*/ // SKYRAT EDIT END
  };
  return next => action => {
    const { type, payload } = action;
    if (!initialized) {
      initialized = true;
      interval = setInterval(sendPing, PING_INTERVAL);
      sendPing();
    }
    if (type === 'roundrestart') {
      // Stop pinging because dreamseeker is currently reconnecting.
      // Topic calls in the middle of reconnect will crash the connection.
      clearInterval(interval);
      return next(action);
    }
    if (type === 'pingReply') {
      const { index } = payload;
      const ping = pings[index];
      // Received a timed out ping
      if (!ping) {
        return;
      }
      pings[index] = null;
      return next(pingSuccess(ping));
    }
    return next(action);
  };
};
