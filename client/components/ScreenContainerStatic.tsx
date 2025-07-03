import { ReactNode } from 'react';
import { SafeAreaView } from 'react-native-safe-area-context';

export default function ScreenContainerStatic({ children }: { children: ReactNode }) {
    return (
        <SafeAreaView className="flex-1 bg-white">
            {children}
        </SafeAreaView>
    );
}
