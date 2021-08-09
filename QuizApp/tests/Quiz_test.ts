
import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v0.14.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.90.0/testing/asserts.ts';

Clarinet.test({
    name: "Ensure that adding answer and checking answer works!",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        let wallet_1 = accounts.get('wallet_1')!;
        let block = chain.mineBlock([
           
            Tx.contractCall('Quiz', 'get-score', [], wallet_1.address),
            Tx.contractCall('Quiz', 'add-answer', [types.uint(2), types.ascii("Clarity")], wallet_1.address),
            Tx.contractCall('Quiz', 'check-answer', [types.uint(2), types.ascii("Clarity")], wallet_1.address),
            Tx.contractCall('Quiz', 'get-score', [], wallet_1.address),
        ]);
        
        // Number of transactions in the block
        assertEquals(block.receipts.length, 4);

        // Number of blocks mined are equal to 2 
        assertEquals(block.height, 2);
        
        // Before increasing score. Expected value is 0
        block.receipts[0].result
            .expectOk()
            .expectUint(0)
        
        // After increasing score. Expected value is 1
        block.receipts[3].result
            .expectOk()
            .expectUint(1)  
        
    },
});
