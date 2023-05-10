import { debugData } from "../../utils/debugData";
import type { NotificationProps } from "../../typings/Notification";

export const debugNotification = () => {
  debugData([
    {
      action: 'supv:notification:send',
      data: {
        //id: '1',
        title: 'Titre de la notification',
        description: 'Notif',
        type: 'info',
        position: 'top-right',
        style: {
          backgroundImage: `linear-gradient(to left bottom, rgba(39,54,102,0.38), rgba(36,51,98,0.38), rgba(34,48,94,0.38), rgba(31,46,90,0.38), rgba(29,43,86,0.38), rgba(31,40,81,0.38), rgba(32,36,75,0.38), rgba(32,33,70,0.38), rgba(34,29,62,0.38), rgba(34,24,54,0.38), rgba(33,21,46,0.38), rgba(31,17,39,0.38))`,
          transition: 'all 0.3s ease-in-out',
          color: '#0FBA81',
          borderRadius: '5px',
          boxShadow: '0 0 10px 0 rgba(0,0,0,0.2)',
          
        }
        //duration: 5000,
        //progress: true,
        //closable: true,
      } as NotificationProps,
    }
  ]);
  /*
  debugData([
    {
      action: 'supv:notification:send',
      data: {
        id: '2',
        title: 'Whereas recognition of the inherent dignity',
        description: '~r~Notification~r~ ~p~description~p~\nwith new line',
        type: 'success',
        position: 'top-right',
        //duration: 5000,
        //progress: true,
        //closable: true,
      } as NotificationProps,
    }
  ]);
  debugData([
    {
      action: 'supv:notification:send',
      data: {
        //title: 'Whereas recognition of the inherent dignity',
        description: 'Notification description\nwith new line',
        type: 'error',
        position: 'top-right',
        //duration: 5000,
        //progress: true,
        //closable: true,
      } as NotificationProps,
    }
  ]);
  debugData([
    {
      action: 'supv:notification:send',
      data: {
        //title: 'Whereas recognition of the inherent dignity',
        description: 'Celle-ci je peux la fermer',
        type: 'info',
        position: 'top-right',
        //duration: 5000,
        //progress: true,
        closable: true,
      } as NotificationProps,
    }
  ]);
  debugData([
    {
      action: 'supv:notification:send',
      data: {
        title: 'Une notification avec un titre type loading',
        //description: 'Loading',
        type: 'loading',
        position: 'top-right',
        //duration: 5000,
        //progress: true,
        closable: true,
      } as NotificationProps,
    }
  ]);
  debugData([
    {
      action: 'supv:notification:send',
      data: {
        title: 'Une notification avec un titre sans type',
        //description: 'Loading',
        //type: 'loading',
        position: 'top-right',
        //duration: 5000,
        //progress: true,
        closable: true,
      } as NotificationProps,
    }
  ]);
  debugData([
    {
      action: 'supv:notification:send',
      data: {
        title: 'Une notification avec un titre avec icon sans type',
        //description: 'Loading',
        //type: 'loading',
        //position: 'bottom-right',
        //duration: 5000,
        //progress: true,
        iconAnim: 'fade',
        icon: 'x-ray',
        closable: true,
      } as NotificationProps,
    }
  ]);
  debugData([
    {
      action: 'supv:notification:send',
      data: {
        title: 'Un bloc de code',
        //description: "```lua\nfunction(data)\n\tprint(data)\nend\n```",

        //type: 'loading',
        //position: 'bottom-right',
        //duration: 5000,
        //progress: true,
        color: 'dark.4',
        iconAnim: 'beat',
        icon: 'code',
      } as NotificationProps,
    }
  ]);
  
  debugData([
    {
      action: 'supv:notification:send',
      data: {
        title: 'MarkDown',
        description: `
        ~r~Markdown~r~
`,
        //type: 'loading',
        //position: 'bottom-right',
        //duration: 5000,
        //progress: true,
        iconAnim: 'fade',
        icon: 'code',
        closable: true,
        style: {
          backgroundColor: 'rgba(0,0,0,0.385)',
        }
      } as NotificationProps,
    }
  ]);*/
} // screwdriver-wrench