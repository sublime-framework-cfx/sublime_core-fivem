import React, { useState } from 'react';
import { MantineProvider, ColorSchemeProvider, ColorScheme } from '@mantine/core';
import { themeOverride } from './theme';

// Features //
//import {useConfig} from './providers/ConfigProvider'; // TODO: use config
import NotificationsWrapper from './features/notify/NotificationsWrapper';
import ModalWrapper from './features/modal/ModalWrapper';
import {MainProfilesMenu, Login} from './features/profils/index';
import ConvertUnixTime from './features/tool/ConvertUnix';

//import ChatText from './features/chat/Chat';
//import DialogComponent from './features/dialog/Dialog';

// Dev //
import { isEnvBrowser } from './utils/misc';
import DevTool from './dev/DevEnv';

const App: React.FC = () => {
    //const { config } = useConfig(); // TODO: use config
    const [colorScheme, setColorScheme] = useState<ColorScheme>('dark');
    const toggleColorScheme = (value?: ColorScheme) => setColorScheme(value || (colorScheme === 'dark' ? 'light' : 'dark'));
    
    return (
        <>
            <ColorSchemeProvider colorScheme={colorScheme} toggleColorScheme={toggleColorScheme}>
                <MantineProvider theme={{colorScheme, ...themeOverride}} withGlobalStyles withNormalizeCSS>
                    {/*<ChatText />*/}
                    <Login />
                    <MainProfilesMenu />
                    <ConvertUnixTime />
                    <ModalWrapper />
                    <NotificationsWrapper />
                    {isEnvBrowser() && <DevTool />}
                </MantineProvider>
            </ColorSchemeProvider>
        </>
    )
}

export default App;