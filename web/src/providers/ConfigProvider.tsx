import { Context, createContext, useContext, useEffect, useState } from 'react';
import { MantineColor } from '@mantine/core';
import { fetchNui } from '../utils/fetchNui';
import { 
  NotificationConfigProviderProps,
  EmojiPickerProps,
  ModalsProviderProps
} from '../typings';
import {
  NotificationConfigDev,
  ConfigEmojiPicker,
  ModalsConfigDev
} from '../dev/config';

interface Config {
  primaryColor: MantineColor;
  primaryShade: 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9;
  notificationStyles: NotificationConfigProviderProps;
  modalsStyles: ModalsProviderProps;
  emojiPicker: EmojiPickerProps;
}

interface ConfigCtxValue {
  config: Config;
  setConfig: (config: Config) => void;
}

const ConfigCtx = createContext<{ config: Config; setConfig: (config: Config) => void } | null>(null);

const ConfigProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [config, setConfig] = useState<Config>({
    primaryColor: 'blue',
    primaryShade: 6,
    notificationStyles: NotificationConfigDev,
    modalsStyles: ModalsConfigDev,
    emojiPicker: ConfigEmojiPicker,
  });

  useEffect(() => {
    fetchNui<Config>('sl:react:config').then((data) => setConfig(data));
  }, []);

  return <ConfigCtx.Provider value={{ config, setConfig }}>{children}</ConfigCtx.Provider>;
};

export default ConfigProvider;

export const useConfig = () => useContext<ConfigCtxValue>(ConfigCtx as Context<ConfigCtxValue>);