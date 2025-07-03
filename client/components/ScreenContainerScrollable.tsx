import { ReactNode } from 'react';
import { SafeAreaView, useSafeAreaInsets } from 'react-native-safe-area-context';
import { ScrollView } from 'react-native';

export default function ScreenContainerScrollable({ children }: { children: ReactNode }) {
    const insets = useSafeAreaInsets();

    return (
        <SafeAreaView className="flex-1 bg-white">
            <ScrollView
                className="flex-1"
                contentContainerStyle={{ flexGrow: 1, paddingBottom: insets.bottom }}
                keyboardShouldPersistTaps="handled"
            >
                {children}
            </ScrollView>
        </SafeAreaView>
    );
}
