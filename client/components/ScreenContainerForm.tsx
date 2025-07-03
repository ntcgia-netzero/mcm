// components/ScreenContainer.tsx
import { ReactNode } from 'react';
import { SafeAreaView, useSafeAreaInsets } from 'react-native-safe-area-context';
import { KeyboardAvoidingView, ScrollView, Platform } from 'react-native';

type Props = {
    children: ReactNode;
};

export default function ScreenContainerForm({ children }: Props) {
    const insets = useSafeAreaInsets();

    return (
        <SafeAreaView className={`flex-1 bg-white`}>
            <KeyboardAvoidingView
                className="flex-1"
                behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
            >
                <ScrollView
                    className="flex-1"
                    contentContainerStyle={{ flexGrow: 1, paddingBottom: insets.bottom }}
                    keyboardShouldPersistTaps="handled"
                >
                    {children}
                </ScrollView>
            </KeyboardAvoidingView>
        </SafeAreaView>
    );
}
